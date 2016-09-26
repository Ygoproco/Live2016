--十二獣ラム
--Juunishishi Ram
--Scripted by Eerie Code
function c7518.initial_effect(c)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7518,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c7518.spcon)
	e3:SetTarget(c7518.sptg)
	e3:SetOperation(c7518.spop)
	c:RegisterEffect(e3)
	--get effect
	if not c7518.global_check then
		c7518.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c7518.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function c7518.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c7518.spfilter(c,e,tp)
	return c:IsSetCard(0xf2) and not c:IsCode(7518) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7518.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7518.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c7518.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7518.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7518.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c7518.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) and tc:GetOriginalRace()==RACE_BEASTWARRIOR
			and tc:GetFlagEffect(7518)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(7518,1))
			e1:SetCategory(CATEGORY_NEGATE)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_CHAINING)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c7518.negcon)
			e1:SetTarget(c7518.negtg)
			e1:SetOperation(c7518.negop)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(7518,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function c7518.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_TRAP)
end
function c7518.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c7518.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
