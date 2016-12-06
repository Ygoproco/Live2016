--D/D Brownie
function c511009383.initial_effect(c)

	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66762372,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c511009383.settg)
	e2:SetOperation(c511009383.setop)
	c:RegisterEffect(e2)
	
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c511009383.effcon)
	e3:SetOperation(c511009383.regop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17540705,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c511009383.sccon)
	e4:SetCost(c511009383.sccost)
	e4:SetTarget(c511009383.sctg)
	e4:SetOperation(c511009383.scop)
	c:RegisterEffect(e4)
end

function c511009383.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp
end
function c511009383.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009383.cfilter,1,nil,tp)
end
function c511009383.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009383.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c511009383.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c511009383.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(511009383+1,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c511009383.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(511009383+1)~=0
end
function c1474910.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c511009383.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c511009383.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.CheckReleaseGroup(tp,c1474910.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c1474910.cfilter,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c511009383.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c511009383.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009383.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c511009383.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511009383.scop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
