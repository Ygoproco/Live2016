--No.80 狂装覇王ラプソディ・イン・バーサーク
function c513000062.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(876330,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c513000062.eqtg)
	e1:SetOperation(c513000062.eqop)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(612115,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c513000062.rmcost)
	e2:SetTarget(c513000062.rmtg)
	e2:SetOperation(c513000062.rmop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c513000062.indes)
	c:RegisterEffect(e3)
	if not c513000062.global_check then
		c513000062.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c513000062.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c513000062.xyz_number=80
function c513000062.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c513000062.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1200)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c513000062.eqlimit)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)	
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c513000062.btcon)
	e3:SetCost(c513000062.btcost)
	e3:SetOperation(c513000062.btop)
	e3:SetRange(LOCATION_SZONE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c513000062.con)
	e4:SetCost(c513000062.btcost)
	e4:SetOperation(c513000062.op)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)	
end
function c513000062.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c513000062.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c513000062.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c513000062.rmfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToRemove()
end
function c513000062.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,typ)
	local a=g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
	local b=g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
	local c=g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
	local op=3
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53839837,5))
	if a and b and c then
		op=Duel.SelectOption(tp,aux.Stringid(53839837,1),aux.Stringid(53839837,2),aux.Stringid(53839837,3))
	elseif a and b then
		op=Duel.SelectOption(tp,aux.Stringid(53839837,1),aux.Stringid(53839837,2))
	elseif b and c then
		op=Duel.SelectOption(tp,aux.Stringid(53839837,2),aux.Stringid(53839837,3))
		op=op+1
	elseif a and c then
		op=Duel.SelectOption(tp,aux.Stringid(53839837,1),aux.Stringid(53839837,3))
		if op==1 then op=op+1 end
	elseif a then
		Duel.SelectOption(tp,aux.Stringid(53839837,1))
		op=0
	elseif b then
		Duel.SelectOption(tp,aux.Stringid(53839837,2))
		op=1
	elseif c then
		Duel.SelectOption(tp,aux.Stringid(53839837,3))
		op=2
	end
	local type=0
	if op==0 then type=TYPE_MONSTER
	elseif op==1 then type=TYPE_SPELL
	elseif op==2 then type=TYPE_TRAP end
	local sg=g:Filter(c513000062.rmfilter,nil,type)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c513000062.btcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=1000
end
function c513000062.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	if chk==0 then return c:IsDestructable() and c:IsAbleToGraveAsCost() end
	Duel.Destroy(c,REASON_COST)
	Duel.SendtoGrave(c,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67441435,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c513000062.spcost)
	e1:SetTarget(c513000062.sptg)
	e1:SetOperation(c513000062.spop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c513000062.btop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c513000062.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c513000062.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c513000062.con(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and cv>=1000 then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER) and cv>=1000 
end
function c513000062.op(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c513000062.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c513000062.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return val/2
end
function c513000062.spcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c513000062.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c513000062.spcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c513000062.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c513000062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c513000062.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c513000062.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,93568288)
	Duel.CreateToken(1-tp,93568288)
end
function c513000062.indes(e,c)
	return not c:IsSetCard(0x48)
end
