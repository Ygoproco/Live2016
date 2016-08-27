--光波分光
--Cipher Spectrum
--Scripted by Eerie Code
function c7569.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7569.target)
	e1:SetOperation(c7569.activate)
	c:RegisterEffect(e1)
	if not c7569.global_check then
		c7569.global_check=true
		--These group keep informations on the valid targets involved in the current Chain or battle for each player.
		--The old version used flags, but it was not reliable.
		c7569.match_cards_battle={}
		c7569.match_cards_battle[0]=Group.CreateGroup()
		c7569.match_cards_battle[1]=Group.CreateGroup()
		c7569.match_cards_battle[0]:KeepAlive()
		c7569.match_cards_battle[1]:KeepAlive()
		c7569.match_cards_effect={}
		c7569.match_cards_effect[0]=Group.CreateGroup()
		c7569.match_cards_effect[1]=Group.CreateGroup()
		c7569.match_cards_effect[0]:KeepAlive()
		c7569.match_cards_effect[1]:KeepAlive()
		--At the start of a battle, valid cards are added to the newly emptied battle group.
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_START)
		ge1:SetOperation(c7569.checkop_b)
		Duel.RegisterEffect(ge1,tp)
		--When a Chain is resolving, all valid cards involved are added to the effect group.
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_SOLVING)
		ge2:SetOperation(c7569.checkop_e)
		Duel.RegisterEffect(ge2,tp)
		--The effect group is emptied whenever a new chain is started, except when the first effect involved is Cipher Spectrum.
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAIN_ACTIVATING)
		ge3:SetOperation(c7569.reset_e)
		Duel.RegisterEffect(ge3,tp)
	end
end

function c7569.checkfil(c)
	return c:IsSetCard(0xe5) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c7569.checkop_b(e,tp,eg,ep,ev,re,r,rp)
	c7569.match_cards_battle[0]:Clear()
	c7569.match_cards_battle[1]:Clear()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and c7569.checkfil(a) then
		c7569.match_cards_battle[a:GetControler()]:AddCard(a)
	end
	if d and c7569.checkfil(d) then
		c7569.match_cards_battle[d:GetControler()]:AddCard(d)
	end
end
function c7569.checkop_e(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c7569.checkfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if not c7569.match_cards_effect[tc:GetControler()]:IsContains(tc) then
			c7569.match_cards_effect[tc:GetControler()]:AddCard(tc)
		end
		tc=g:GetNext()
	end
end
function c7569.reset_e(e,tp,eg,ep,ev,re,r,rp)
	local cl=Duel.GetCurrentChain()
	if cl<=1 and not re:GetHandler():IsCode(7569) then
		c7569.match_cards_effect[0]:Clear()
		c7569.match_cards_effect[1]:Clear()
	end
end

function c7569.cfil(c,e,tp)
	if c:IsReason(REASON_BATTLE) and not c7569.match_cards_battle[tp]:IsContains(c) then
		return false
	elseif c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp and not c7569.match_cards_effect[tp]:IsContains(c) then
		return false
	elseif not c:IsReason(REASON_BATTLE+REASON_EFFECT) then
		return false
	elseif not c:IsLocation(LOCATION_GRAVE) then
		return false
	elseif not c:IsControler(tp) then
		return false
	elseif not c:IsCanBeEffectTarget(e) then
		return false
	elseif not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		return false
	elseif not Duel.IsExistingMatchingCard(c7569.fil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode()) then
		return false
	else return true end
end
function c7569.fil(c,e,tp,cd)
	return c:IsType(TYPE_XYZ) and c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7569.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c7569.cfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and eg:IsExists(c7569.cfil,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,c7569.cfil,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7569.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c7569.fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
